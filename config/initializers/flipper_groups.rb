Flipper.register(:admins) do |actor|
  # Define admin users for Flipper feature flags
  actor.respond_to?(:admin?) && actor.admin?
end