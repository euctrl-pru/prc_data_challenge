teams_file := justfile_directory() + "/media/teams_private.json"

[private]
@default:
  just --list

# retrieve active teams from API
@teams:
  curl -X 'GET' \
    'http://192.168.30.14/api/teams/admin/get-all?activeTeamsOnly=true' \
    -H 'accept: application/json' \
    -H 'Authorization: Basic YWRtaW46RHRVNmNLeEY5aWdsdENBaTFyekU='

# save teams locally (sorted by registration date)
[confirm("Are you sure you want to update local teams file (you need VPN)?")]
@teams-update:
  just teams | jq -r '. | sort_by(.registration_date) ' > {{teams_file}}

# remove email addresses
@teams-no-emails:
  cat {{teams_file}} | jq 'del(.[] | .members[] | .email)'

# team names
@teams-name:
  cat {{teams_file}} | jq -r '.[] | .team_name'

# leaders' emails
@teams-email:
  cat {{teams_file}} | jq -r '.[] | .members[] | select(.leader == true) | .email'


# team for team's name 
@team-of-name team_name:
  cat {{teams_file}} | \
    jq '.[] | select(.active == true) | select(.team_name == "{{team_name}}") | .'

# team's name for leader's email
@team-of-leader leader_email:
  cat {{teams_file}} | \
    jq '.[] | select(.active == true) | select(.members[].leader == true and .members[].email == "{{leader_email}}") | .'

# update _teams.qmd
@teams-qmd-include:
  #!/usr/bin/env sh
  cat media/teams_private.json | jq -r '.[] | .team_name' | sort | sed 's/$/.qmd >}}/;s/^/{{{{< include teams\//' > _teams.qmd 
