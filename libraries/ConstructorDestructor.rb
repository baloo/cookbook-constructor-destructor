

class ConstructorDestructor
  @@startup = []
  @@shutdown = []
  @@cache_startup = []

  def self.cache_startup(recipes = nil)
    if recipes
      @@cache_startup = recipes
    else
      @@cache_startup
    end
  end

  def self.startup_append(order, recipe)
    @@startup << {:order => order, :recipe => recipe}
  end

  def self.startup
    @@startup.sort{|a, b|
      a[:order] <=> b[:order]
    }.map{|e|
      e[:recipe]
    }
  end

  def self.shutdown_append(order, recipe)
    Chef::Log.info("Appending #{recipe}")
    @@shutdown << {:order => order, :recipe => recipe}
  end

  def self.shutdown
    @@shutdown.sort{|a, b|
      a[:order] <=> b[:order]
    }.map{|e|
      e[:recipe]
    }
  end

  # Helper function for validating constructor recipe is the first of run_list
  def self.ensure_first(node)
    run_list = node.run_list.clone
    if run_list.first != 'constructor_destructor::constructor'
      run_list.delete('constructor_destructor::constructor')
    end

    # unshift
    run_list[0] = Chef::RunList::RunListItem.new('constructor_destructor::constructor')
    key = 0
    node.run_list.each do |value|
      key += 1
      run_list[key] = value.to_s
    end

    node.run_list = run_list
    node.save
  end

  # Helper function for validating constructor recipe is the last of run_list
  def self.ensure_last(node)
    run_list = node.run_list
    if run_list.first != 'constructor_destructor::destructor'
      run_list.remove('constructor_destructor::destructor')
    end
    run_list.push(Chef::RunList::RunListItem.new('constructor_destructor::destructor'))
    node.run_list = run_list

    node.save
  end

end


