# frozen_string_literal: true

# Routes of project
Rails.application.routes.draw do
  get 'companies_dashboards/index'

  root 'dashboards#index'

  get 'job_posts/search'

  get 'admins/companies'
  get 'admins/jobseekers'
  get 'admins/job_posts'
  get 'admins/index'
  get 'admins/resumes'
  get 'admins/user_list'
  get 'admins/applied_job/:user_id' => 'admins#applied_job',
      as: :admin_applied_job
  delete 'admins/destroy_jobseeker/:user_id' => 'admins#destroy_jobseeker',
         as: :admin_destroy_jobseeker

  devise_for :companies, controllers: {
    registrations: 'companies/registrations',
    sessions: 'companies/sessions'
  }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users do
    resources :job_posts, only: %i[index show] do
      get 'apply_job', on: :member
      get 'apply_job_destroy', on: :member
      member do
        get 'apply_job'
      end
    end
  end
  resources :resumes
  resources :charges
  resources :apply_jobs
  resources :companies do
    resources :reviews do
      collection do
        get 'review_list'
      end
    end
    resources :job_posts do
      member do
        get 'view_candidates'
      end
      collection do
        get 'company_jobs_list'
      end
    end
  end
  if Rails.env.development?
    scope format: true, constraints: { format: /jpg|png|gif|PNG/ } do
      get '/*anything',
          to: proc { [404, {}, ['']] },
          constraints: lambda { |request|
                         !request.path_parameters[:anything]
                                 .start_with?('rails/')
                       }
    end
  end

  # match '*unmatched', to: 'application#route_not_found', via: :all
end
