class InvitationsController < ApplicationController

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    @invitation = Invitation.find_by_code(params[:id])
    if @invitation
      @ballot_box = @invitation.ballot_box
      @vote = @ballot_box.votes.build
      
      respond_to do |format|
        format.html 
        format.json { render json: @invitation }
      end
    end
  end
end
