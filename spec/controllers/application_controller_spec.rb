require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  subject(:new_application) { described_class.new }

  context 'when devise permits parameters' do
    let(:params)     { instance_double('Mocked Devise parameters') }
    let(:attributes) { %i[username email email_confirmation] }

    it 'includes username, email and email_confirmation' do
      allow(params).to receive(:permit).with(:sign_up, keys: attributes)
      is_expected.to receive(:devise_parameter_sanitizer).and_return(params)

      new_application.send(:configure_permitted_parameters)
    end
  end
end
