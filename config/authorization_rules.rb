# Default role is :guest
authorization do
  role :admin do
    has_permission_on :reservations, :to => [:new, :index, :show, :update, :delete, :create, :destroy]
    has_permission_on :application, :to => [:welcome, :about]
    has_permission_on :admin_subnets, :to => [:index, :create, :destroy]
    has_permission_on :subnets, :to => [:create, :delete]
  end
  role :access do
    has_permission_on :reservations, :to => [:new, :index, :show, :update, :delete, :create, :destroy]
    has_permission_on :application, :to => [:welcome]
  end
  role :guest do
    has_permission_on :application, :to => [:welcome]
  end
end
