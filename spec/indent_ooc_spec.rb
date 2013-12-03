
require 'spec_helper'

samples.each do |sample|
  describe sample do
    specify 'indentation should correspond to reference' do
      write_file('test.ooc', IO.read(sample).rstrip)
      vim.edit 'test.ooc'
      do_indent(vim)
      IO.read('test.ooc').rstrip.should eq IO.read("#{sample}.ref").rstrip
    end
  end
end

