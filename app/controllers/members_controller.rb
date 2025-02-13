require 'byebug'
class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy ]

  # GET /members or /members.json
  def index
    @members = Member.all
  end

  def invite
    current_tenant = Tenant.first
    email = params[:email]
    if email && !email.empty?
      user_from_email = User.where(email: email).first
      if user_from_email.present?
        if Member.where(user: user_from_email, tenant: current_tenant).any?
          redirect_to members_path, alert: "The Organisation #{current_tenant.name} already has a User with the email #{email}"
        else
          Member.create!(user: user_from_email, tenant: current_tenant)
          redirect_to mrembers_path, notice: "#{email} was Invited to Join the organisation #{current_tenant.name}"
        end
      elsif user_from_email.nil? #invite new user to a tenat
        new_user = User.invite!(email: email) #devise_invitable
        Member.create!(user: new_user, tenant: current_tenant)
        redirect_to members_path, notice: "#{email} was Invited to Join the Tenant #{current_tenant.name}"
      end
    end
     
  end

  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy!

    respond_to do |format|
      format.html { redirect_to members_path, status: :see_other, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:user_id, :tenant_id)
    end
end
