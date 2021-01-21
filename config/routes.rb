Rails.application.routes.draw do
  # see Rails Tutorial 5.3.2 to see how root_path etc are formed
  root "static_pages#home"
  get 'static_pages/home'
  get '/help',     to: 'static_pages#help'#, as: "helf"
  get '/about',    to: 'static_pages#about'
  get '/contact',  to: 'static_pages#contact'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
