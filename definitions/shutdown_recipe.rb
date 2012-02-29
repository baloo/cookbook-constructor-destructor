
define :shutdown_recipe, :action => :enable, :weight => 10 do
  # Ensure startup recipe is defined
  ConstructorDestructor.ensure_last(node)

  ConstructorDestructor.shutdown_append(params[:weight], params[:recipe])
end

