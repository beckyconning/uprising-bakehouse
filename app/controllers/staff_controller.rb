class StaffController < ApplicationController
  def index
    if staff_member_signed_in?
    else
      redirect_to new_staff_member_session_path
    end
  end
end
