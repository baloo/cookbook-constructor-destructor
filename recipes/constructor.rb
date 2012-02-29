#
# Cookbook Name:: constructor_destructor
# Recipe:: constructor
#
# Copyright 2012, Zenexity
#
# All rights reserved - Do Not Redistribute
#

startup_recipes = node[:constructor_destructor][:startup]

# First save current value
ConsctructorDestructor.cache_startup(startup_recipes)

# Then try to run cookbooks stored
startup_recipes.each do |recipe|
  begin
    include_recipe(recipe)
  rescue e
    Chef::Log.warn("Recipe #{recipe} is not available anymore")
  end
end



