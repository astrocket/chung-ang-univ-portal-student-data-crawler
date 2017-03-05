Rails.application.routes.draw do


  resource :parsers
  get 'parsers/get_notice_detail(:format)' , to: 'parsers#get_notice_detail' , as: 'notice_detail'

  resource :classrooms

  root 'parsers#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
