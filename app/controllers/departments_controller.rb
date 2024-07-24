class DepartmentsController < ApplicationController
    def index
        @departments = Department.all
    end

    def show
        @department = Department.find(params[:id])
    end

    def new
        @department =  Department.new
    end

    def create
        @department = Department.new(params_department)
        if @department.save
            redirect_to @department
        else
            render :new
        end
    end

    def edit
        @department = Department.find(params[:id])
    end

    def update
        @department= Department.find(params[:id])
       if  @department.update(params_department)
        redirect_to departments_url
        else
            render :edit
        end
    end

    def destroy
        @department = Department.find(params[:id])
        @department.destroy
        redirect_to root_path, status: :see_other
    end

    private

    def params_department
        params.require(:department).permit(:code, :department_name)
    end
end