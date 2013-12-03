
require 'spec_helper'

samples.each do |sample|
  describe sample do
    specify 'indentation should correspond to reference' do
      write_file('test.ooc', IO.read(sample).rstrip)
      vim.edit 'test.ooc'
      vim.set('ft', 'ooc')
      vim.normal "gg=G" # go to beginning, indent all
      sleep(0.1) # give it time, otherwise it might write the non-indented version
      vim.write
      IO.read('test.ooc').rstrip.should eq IO.read("#{sample}.ref").rstrip
    end
  end
end

