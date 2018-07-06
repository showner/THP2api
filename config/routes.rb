Rails.application.routes.draw do
  namespace :v1 do
    resources :lessons, except: %i[new edit]
  end
end
