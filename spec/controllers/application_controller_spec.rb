require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#configure_permitted_parameters' do
    let(:parameters) { class_double('devise_parameters') }
    let(:attributes) { %i[username email email_confirmation] }

    it 'permit params' do
      expect(parameters).to receive(:permit).with(:sign_up, keys: attributes)
      expect(subject).to receive(:devise_parameter_sanitizer).and_return(parameters)
      subject.send(:configure_permitted_parameters)
    end
  end
end
