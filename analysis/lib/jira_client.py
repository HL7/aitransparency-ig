"""Jira REST API client for HL7's Jira Server instance.

Handles authentication, field discovery, paginated search, and single-issue
retrieval against jira.hl7.org (Jira Server / Data Center REST API v2).
"""

import logging
import requests

logger = logging.getLogger(__name__)


class JiraError(Exception):
    """Raised when a Jira API call fails."""


class JiraClient:
    """Thin wrapper around the Jira Server REST API v2.

    Args:
        base_url: Jira instance URL (e.g. "https://jira.hl7.org").
        pat: Personal Access Token for Bearer authentication.
        page_size: Max results per search page (Jira caps at 50).
    """

    def __init__(self, base_url, pat, page_size=50):
        self.base_url = base_url.rstrip("/")
        self.api_url = f"{self.base_url}/rest/api/2"
        self.page_size = min(page_size, 50)  # Jira hard limit

        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {pat}",
            "Accept": "application/json",
            # HL7's Jira is behind an AWS WAF with a
            # SignalNonBrowserUserAgent rule that blocks requests without
            # a browser-style User-Agent header.
            "User-Agent": (
                "Mozilla/5.0 (compatible; HL7-IG-Analysis/1.0; "
                "+https://github.com/HL7/fhir-ai-transparency)"
            ),
        })

    # -- Field discovery -------------------------------------------------- #

    def discover_fields(self):
        """Fetch all Jira fields and return a dict mapping name -> field id.

        This is needed because "Specification" is a custom field whose id
        (e.g. ``customfield_12316``) varies by instance.
        """
        url = f"{self.api_url}/field"
        resp = self._get(url)
        return {f["name"]: f["id"] for f in resp}

    def find_specification_field(self):
        """Return the field id for the 'Specification' custom field.

        Raises JiraError if the field is not found.
        """
        fields = self.discover_fields()
        for name, field_id in fields.items():
            if name.lower() == "specification":
                logger.info("Found Specification field: %s -> %s", name, field_id)
                return field_id
        raise JiraError(
            "Could not find a field named 'Specification'. "
            f"Available fields containing 'spec': "
            f"{[n for n in fields if 'spec' in n.lower()]}"
        )

    # -- Search ----------------------------------------------------------- #

    def search_issues(self, jql, fields=None):
        """Search for issues using JQL with full pagination.

        Args:
            jql: JQL query string.
            fields: List of field names/ids to include in results.
                    Defaults to a useful subset if not specified.

        Returns:
            List of issue dicts as returned by the Jira API.
        """
        if fields is None:
            fields = [
                "summary", "status", "issuetype", "priority",
                "resolution", "created", "updated", "description",
                "labels", "comment", "assignee", "reporter", "components",
            ]

        all_issues = []
        start_at = 0

        while True:
            params = {
                "jql": jql,
                "startAt": start_at,
                "maxResults": self.page_size,
                "fields": ",".join(fields),
            }
            data = self._get(f"{self.api_url}/search", params=params)

            issues = data.get("issues", [])
            all_issues.extend(issues)

            total = data.get("total", 0)
            logger.info(
                "Fetched issues %d–%d of %d",
                start_at + 1,
                start_at + len(issues),
                total,
            )

            start_at += len(issues)
            if start_at >= total or not issues:
                break

        return all_issues

    # -- Single issue ----------------------------------------------------- #

    def get_issue(self, key):
        """Fetch a single issue by its key (e.g. 'FHIR-12345').

        Returns the full issue dict.
        """
        url = f"{self.api_url}/issue/{key}"
        return self._get(url)

    # -- Internal helpers ------------------------------------------------- #

    def _get(self, url, params=None):
        """Make a GET request and return parsed JSON.

        Raises JiraError with a helpful message on failure.
        """
        try:
            resp = self.session.get(url, params=params, timeout=30)
        except requests.ConnectionError as exc:
            raise JiraError(f"Could not connect to {self.base_url}: {exc}") from exc
        except requests.Timeout as exc:
            raise JiraError(f"Request timed out: {url}") from exc

        if resp.status_code == 401:
            raise JiraError(
                "Authentication failed (HTTP 401). "
                "Check that your PAT is valid and not expired."
            )
        if resp.status_code == 403:
            raise JiraError(
                "Authorization denied (HTTP 403). "
                "Your PAT may lack permission for this resource."
            )
        if resp.status_code == 404:
            raise JiraError(f"Not found (HTTP 404): {url}")
        if not resp.ok:
            raise JiraError(
                f"Jira API error (HTTP {resp.status_code}): {resp.text[:500]}"
            )

        return resp.json()
