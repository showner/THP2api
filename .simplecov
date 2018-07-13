SimpleCov.minimum_coverage 95
SimpleCov.minimum_coverage_by_file 90
SimpleCov.maximum_coverage_drop 5


if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter "/config/"
    add_filter "/spec/support/"

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Serializers', 'app/serializers'
  end
end