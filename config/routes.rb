# == Route Map
#
#                      Prefix Verb   URI Pattern                                                                              Controller#Action
#         new_v1_user_session GET    /v1/auth/sign_in(.:format)                                                               devise_token_auth/sessions#new
#             v1_user_session POST   /v1/auth/sign_in(.:format)                                                               devise_token_auth/sessions#create
#     destroy_v1_user_session DELETE /v1/auth/sign_out(.:format)                                                              devise_token_auth/sessions#destroy
#        new_v1_user_password GET    /v1/auth/password/new(.:format)                                                          devise_token_auth/passwords#new
#       edit_v1_user_password GET    /v1/auth/password/edit(.:format)                                                         devise_token_auth/passwords#edit
#            v1_user_password PATCH  /v1/auth/password(.:format)                                                              devise_token_auth/passwords#update
#                             PUT    /v1/auth/password(.:format)                                                              devise_token_auth/passwords#update
#                             POST   /v1/auth/password(.:format)                                                              devise_token_auth/passwords#create
# cancel_v1_user_registration GET    /v1/auth/cancel(.:format)                                                                devise_token_auth/registrations#cancel
#    new_v1_user_registration GET    /v1/auth/sign_up(.:format)                                                               devise_token_auth/registrations#new
#   edit_v1_user_registration GET    /v1/auth/edit(.:format)                                                                  devise_token_auth/registrations#edit
#        v1_user_registration PATCH  /v1/auth(.:format)                                                                       devise_token_auth/registrations#update
#                             PUT    /v1/auth(.:format)                                                                       devise_token_auth/registrations#update
#                             DELETE /v1/auth(.:format)                                                                       devise_token_auth/registrations#destroy
#                             POST   /v1/auth(.:format)                                                                       devise_token_auth/registrations#create
#    new_v1_user_confirmation GET    /v1/auth/confirmation/new(.:format)                                                      devise_token_auth/confirmations#new
#        v1_user_confirmation GET    /v1/auth/confirmation(.:format)                                                          devise_token_auth/confirmations#show
#                             POST   /v1/auth/confirmation(.:format)                                                          devise_token_auth/confirmations#create
#      v1_auth_validate_token GET    /v1/auth/validate_token(.:format)                                                        devise_token_auth/token_validations#validate_token
#           v1_course_lessons GET    /v1/courses/:course_id/lessons(.:format)                                                 v1/lessons#index
#                             POST   /v1/courses/:course_id/lessons(.:format)                                                 v1/lessons#create
#            v1_course_lesson GET    /v1/courses/:course_id/lessons/:id(.:format)                                             v1/lessons#show
#                             PATCH  /v1/courses/:course_id/lessons/:id(.:format)                                             v1/lessons#update
#                             PUT    /v1/courses/:course_id/lessons/:id(.:format)                                             v1/lessons#update
#                             DELETE /v1/courses/:course_id/lessons/:id(.:format)                                             v1/lessons#destroy
#          v1_course_sessions GET    /v1/courses/:course_id/sessions(.:format)                                                v1/course_sessions#index
#                             POST   /v1/courses/:course_id/sessions(.:format)                                                v1/course_sessions#create
#           v1_course_session GET    /v1/courses/:course_id/sessions/:id(.:format)                                            v1/course_sessions#show
#                             PATCH  /v1/courses/:course_id/sessions/:id(.:format)                                            v1/course_sessions#update
#                             PUT    /v1/courses/:course_id/sessions/:id(.:format)                                            v1/course_sessions#update
#                             DELETE /v1/courses/:course_id/sessions/:id(.:format)                                            v1/course_sessions#destroy
#                  v1_courses GET    /v1/courses(.:format)                                                                    v1/courses#index
#                             POST   /v1/courses(.:format)                                                                    v1/courses#create
#                   v1_course GET    /v1/courses/:id(.:format)                                                                v1/courses#show
#                             PATCH  /v1/courses/:id(.:format)                                                                v1/courses#update
#                             PUT    /v1/courses/:id(.:format)                                                                v1/courses#update
#                             DELETE /v1/courses/:id(.:format)                                                                v1/courses#destroy
#          rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#   rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#          rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#   update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#        rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'auth'
    resources :courses, except: %i[new edit] do
      resources :lessons, except: %i[new edit]
      resources :sessions, except: %i[new edit], controller: :course_sessions
    end
    resources :organizations, except: %i[new edit]
  end
end
