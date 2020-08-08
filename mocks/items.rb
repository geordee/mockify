#!/usr/bin/env ruby

require 'erb'
require 'json'
require 'faker'
require 'jbuilder'

def item
  Jbuilder.encode do |json|
    json.id Faker::Number.unique.number(digits: 10)
    json.name Faker::Commerce.product_name
    json.category do
      name = Faker::Commerce.department(max: 1, fixed_amount: true)
      json.name name
      json.id name.codepoints.to_a.reduce(0, :+)
    end
    json.price do
      json.value = Faker::Commerce.price
      json.currency = 'AED'
    end
  end
end

file = File.open(File.join(__dir__, '..', 'data', 'items.json'), 'w+')
items = []
1000.times do
  items << JSON.parse(item)
end
file.write JSON.pretty_generate(items)

file = File.open(File.join(__dir__, '..', 'data', 'items.es.json'), 'w+')
1000.times do
  line = item
  action = { index: {_index: 'items', _id: JSON.parse(line)['id']} }.to_json
  record = [action, line].join("\n")
  file.puts(record)
end
