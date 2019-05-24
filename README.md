# Discrepancy Service

Model-Agnostic Ruby Serivce that detect discrepancies between local and remote data and return a description of those discrepancies.

## How to Run it
```
bundle install
# Change database configurations in db/config.yml
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rspec # to make sure that tests passes
```

## Service Arguments
- external_server: External Data server endpoint to hit.
- model: Local ActiveRecord Model **(You can pass a reference to any model in your application or any class that supports ```where``` operation)**
- keys_to_ignore: Keys in the external data records to ignore when comparing.
- json_data_key: Key of the JSON Object containg the external data json array.
- key_mapping: a map of ```{ remote_key: local_key }``` for fields with different remote and local names e.g. ```{ description: :ad_description }```

**Note: The Service assumes that there's a ```reference``` field in external data records and a corresponding ```external_reference``` column in local data to link between the two records.**

**Note: I've made the assumption that status possible values should have the same naming if they have the same meaning e.g 'active' is not the same as 'enabled'**