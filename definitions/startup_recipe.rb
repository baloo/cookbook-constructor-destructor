
define :startup_recipe, :action => :enable, :weight => 100 do
  # Ensure startup recipe is defined
  ConstructorDestructor.ensure_first(node)

  ConstructorDestructor.startup_append(params[:weight], params[:recipe])
end

