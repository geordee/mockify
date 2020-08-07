#!/usr/bin/env ruby

require 'erb'
require 'json'
require 'faker'

class Item
  def initialize
    @item
    @erb = ERB.new(File.read(File.join(__dir__, 'template.erb')))
  end
  attr_accessor :id, :name,
    :category_id, :category_name,
    :price, :currency

  def to_s
    @erb.result(binding)
  end
end

if __FILE__ == $0

  items = []
  1000.times do
    item = Item.new

    item.id = Faker::Number.unique.number(digits: 10)
    item.name = Faker::Commerce.product_name
    item.category_name = Faker::Commerce.department(max: 1, fixed_amount: true)
    item.category_id = item.category_name.codepoints.to_a.reduce(0, :+)
    item.price = Faker::Commerce.price
    item.currency = 'AED'

    items << JSON.parse(item.to_s)
  end

  File.open(File.join(__dir__, 'data.json'), 'w') { |file| file.write(JSON.pretty_generate(items)) }
end
