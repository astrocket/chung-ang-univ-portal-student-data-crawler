Rails.application.routes.draw do

  devise_for :users

  get 'timemachine/index'

  get 'presenters/notice_detail' ,    to: 'presenters#notice_detail', as: :notice_detail
  get 'presenters/notice_file' ,      to: 'presenters#notice_file', as: :notice_file
  get 'presenters/content_detail' ,   to: 'presenters#content_detail' , as: :content_detail
  get 'presenters/content_file' ,     to: 'presenters#content_file' , as: :content_file
  get 'presenters/share_detail' ,   to: 'presenters#share_detail' , as: :share_detail
  get 'presenters/share_file' ,     to: 'presenters#share_file' , as: :share_file
  get 'presenters/professor_detail',  to: 'presenters#professor_detail' , as: :professor_detail

  resource :classrooms
  get 'classrooms/eclass(:format)' ,  to: 'classrooms#eclass'  , as: :eclass
  get 'timemachine/index(:format)', to: 'timemachine#index', as: :timemachine


  resource :parsers



  root 'parsers#index'

end
