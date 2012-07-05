# Default role is :guest
authorization do
  role :admin do
    has_permission_on :reservations, :to => [:new, :index, :show, :update, :delete]
    has_permission_on :application, :to => [:about]
    has_permission_on :admin_subnets, :to => [:index]
    has_permission_on :subnets, :to => [:create]
  end
  role :access do
    has_permission_on :reservations, :to => [:new, :index, :show, :update, :delete]
  end
  role :guest do
    has_permission_on :application, :to => [:welcome]
  end
end
