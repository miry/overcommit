# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

describe 'template directory' do
  let(:template_dir) { File.join(Overcommit::HOME, 'template-dir') }
  let(:hooks_dir) { File.join(template_dir, 'hooks') }

  it 'contains a hooks directory' do
    File.directory?(hooks_dir).should == true
  end

  describe 'the hooks directory' do
    it 'contains the master hook as an actual file with content' do
      master_hook = File.join(hooks_dir, 'overcommit-hook')
      File.exist?(master_hook).should == true
      File.size?(master_hook).should > 0
      Overcommit::Utils::FileUtils.symlink?(master_hook).should == false
    end

    it 'contains all other hooks as copies of the master hook' do
      Overcommit::Utils.supported_hook_types.each do |hook_type|
        hook_file = File.join(hooks_dir, hook_type)
        master_hook_file = File.join(hooks_dir, 'overcommit-hook')
        expect(FileUtils.compare_file(hook_file, master_hook_file)).to be_truthy, "#{hook_file} is not equal #{master_hook_file}"
      end
    end

    it 'contains no symlinks' do
      Overcommit::Utils.supported_hook_types.each do |hook_type|
        Overcommit::Utils::FileUtils.symlink?(File.join(hooks_dir, hook_type)).should == false
      end
    end
  end
end
