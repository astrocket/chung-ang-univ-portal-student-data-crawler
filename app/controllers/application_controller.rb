class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!

  protect_from_forgery with: :exception


  def checked_by_admin
    #가입해서 인증 된 사람 중 슈퍼유저의 승인을 받지 않은자를 채팅방으로 보낸다.
    if user_signed_in?
      unless current_user.has_role? :admin
        if current_user.sign_in_count > 2 and current_user.status == false
          flash[:toast] = '두번째 로그인 부터는 관리자의 승인을 받아야 사용가능합니다.'
          redirect_to url_for(:controller => :messages, :action => :index) and return
        end
      end
    end
  end

end
