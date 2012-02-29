#
# Cookbook Name:: constructor_destructor
# Recipe:: destructor
#
# Copyright 2012, Zenexity
#
# All rights reserved - Do Not Redistribute
#

shutdown_recipes = node[:constructor_destructor][:shutdown]

# First save new new startup value
node[:constructor_destructor][:startup] = ConstructorDestructor.startup

# First save new new shutdown value
node[:constructor_destructor][:shutdown] = ConstructorDestructor.shutdown
node.save

# Check if startup creation value was the same as the current one
if ConstructorDestructor.startup != ConstructorDestructor.cache_startup
  # Reload chef
end


# Execute shutdown recipes
Chef::Log.info("Calling shutdown recipes")
ruby_block "Shutdown recipes" do
  block do
    result_recipes = Array.new
    ConstructorDestructor.shutdown.each do |recipe_name|
      if node.run_state[:seen_recipes].has_key?(recipe_name)
        Chef::Log.debug("I am not loading #{recipe_name}, because I have already seen it.")
        next
      end

      Chef::Log.info("Loading Recipe #{recipe_name} via shutdown recipes")
      node.run_state[:seen_recipes][recipe_name] = true

      cookbook_name, recipe_short_name = Chef::Recipe.parse_recipe_name(recipe_name)

      run_context = self.is_a?(Chef::RunContext) ? self : self.run_context
      begin
        cookbook = run_context.cookbook_collection[cookbook_name]
        begin
          result_recipes << cookbook.load_recipe(recipe_short_name, run_context)
        rescue ArgumentError
          Chef::Log.warn("Couldn't load recipe #{recipe_name}")
        end
      rescue Chef::Exceptions::CookbookNotFound
        Chef::Log.warn("Couldn't load cookbook #{cookbook_name}")
      end
    end
    #Chef::Log.info(result_recipes)
  end
end


