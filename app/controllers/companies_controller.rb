class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: %w(index show new create)
  before_action :set_company_id, only: %w(show)

  layout 'dashboard'

  def index
    @companies = current_user.companies
  end

  def show
    @company = current_company
  end

  def new
    @company = Company.new
  end

  def create
    company = Company.new(company_params)

    if company.save!
      company.employees.create! user: current_user

      redirect_to companies_path, notice: "Created"
    else
      render :new
    end
  end

  private

  def set_company_id
    current_user.update!(
      company_id: Company.friendly.find(params[:id])&.id
    )
  end

  def company_params
    params.require(:company).permit(
      :name,
    )
  end
end

