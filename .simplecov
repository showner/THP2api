
if ENV["COVERAGE"]
  SimpleCov.start 'rails' do
    add_filter '/config/'
    add_filter '/spec/'
	  add_filter 'app/mailers'
    add_filter 'app/jobs'
    add_filter 'app/channels'
    add_filter do |source_file|
      source_file.lines.count < 7
    end

    add_group 'Serializers', 'app/serializers'
  end
end

SimpleCov.minimum_coverage 95
SimpleCov.minimum_coverage_by_file 90
