Rails.application.routes.draw do

  resource :classrooms
  get 'classrooms/eclass(:format)' , to: 'classrooms#eclass'  , as: :eclass

  resource :parsers
  get 'parsers/ask_notice_detail(:format)' , to: 'parsers#ask_notice_detail' , as: :ask_notice_detail
  get 'parsers/ask_notice_file(:format)' , to: 'parsers#ask_notice_file'  , as: :ask_notice_file


  root 'parsers#index'

end
