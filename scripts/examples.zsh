# get team's all details
curl -X 'GET' \
'http://192.168.30.14/api/teams/admin-get-all?activeTeamsOnly=true' \
-H 'accept: application/json' \
-H 'Authorization: Basic YWRtaW46RHRVNmNLeEY5aWdsdENBaTFyekU=' | \
  jq '.' > media/teams_private.json

# remove email addresses
cat media/teams_private.json | jq 'del(.[] | .members[] | .email)'

# number of teams
cat media/teams_private.json | jq '. | length'

# extract email of leaders
cat media/teams_private.json | jq '.[] | .members[] | select(.leader == true) | .email'

# team matching leader's email
cat media/teams_private.json | jq '.[]  | select(.members[].leader == true and .members[].email == "a.b@c.d") | .'
