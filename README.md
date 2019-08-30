# Convenient

This allows JSON objects to be accessed more conveniently using method names. The values of the hash contained within the object can also be accessed using `[]` like normal hashes can. It is very much based on how the [stripe-ruby](https://github.com/stripe/stripe-ruby) gem handles JSON data. Due to how the object is initialized, regular hashes can be passed in as well.

## Usage

To create a new JSON Object:
```
json = {
    "name": "Steve",
    "skills": ["sitting", "sleeping", "eating"]
}.to_json

obj = Convenient::DataObject.new(json)
=> #<Convenient::DataObject:0x2afa9d3135a4> JSON: {
  "name": "Steve",
  "skills": [
    "sitting",
    "sleeping",
    "eating"
  ]
}

obj.name
=> "Steve"

obj[:name]
=> "Steve"

obj.skills
=> ["sitting", "sleeping", "eating"]

obj.caffeine
=> nil

```
A new DataObject can be initialized with a JSON string or a Hash


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
