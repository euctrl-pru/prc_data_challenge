# combine team creation JSON files in one JSON array
(cd data/teams && jq -n 'reduce inputs as $in (null;. + if $in|type == "array" then $in else [$in] end)' $(find . -name '*.json') > ../teams_creation.json)

