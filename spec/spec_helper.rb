require 'vimrunner'
require 'vimrunner/rspec'

Vimrunner::RSpec.configure do |config|
  # Use a single Vim instance for the test suite
  config.reuse_server = true

  config.start_vim do
    vim = Vimrunner.start_gvim

    # Load ooc indentation
    plugin_path = File.expand_path('../..', __FILE__)
    vim.add_plugin(plugin_path, 'indent/ooc.vim')

    vim
  end
end

# indent
def do_indent(vim)
  vim.set('ft', 'ooc')
  vim.normal "ggvG=" # go to beginning, indent all
  vim.write
end

