
require 'spec_helper'

describe 'indent/ooc.vim' do
  describe 'Basic block behavior' do
    specify 'blocks such as classes, funcs, should be indented correctly' do
      write_file('test.ooc', <<-EOF)
        Dog: class {
        init: func {
        a: Int
        }
        }
      EOF

      vim.edit 'test.ooc'
      do_indent(vim)

      IO.read('test.ooc').rstrip.should eq normalize_string_indent(<<-EOF)
        Dog: class {
            init: func {
                a: Int
            }
        }
      EOF
    end
  end
end

