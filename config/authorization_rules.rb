# Default role is :guest
authorization do
  role :admin do
    has_permission_on :reservations, :to => [:create, :read, :update, :delete]
  end
  role :user do
    has_permission_on :reservations, :to => [:create, :read, :update, :delete]
  end
end
