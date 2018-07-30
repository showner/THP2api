class EnablePgcryptoExtension < ActiveRecord::Migration[5.2]
  def change
    # Old syntax
    # enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'
  end
end
