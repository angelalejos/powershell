#
# Author:: Siddheshwar More (<siddheshwar.more@clogeny.com>)
#
# Copyright:: 2014, Chef, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'powershell_module_resource'

class PowershellModuleProvider < Chef::Provider
  def initialize(powershell_module, run_context)
    super(powershell_module, run_context)
    @powershell_module = powershell_module
  end

  def action_install
    converge_by("Powershell Module '#{@powershell_module.module_name}'") do
      install_module
      Chef::Log.info("Powershell Module '#{@powershell_module.module_name}' installation completed successfully")
    end
  end

  def load_current_resource
  end

  def install_module
    fail ArgumentError, "Required attribute 'module_path' or 'download_from' for module installation" unless @new_resource.module_path || @new_resource.download_from

    fail ArgumentError, "Required attribute 'module_name' for module installation" unless @new_resource.module_name

    ps_module_path = FileUtils::mkdir_p("#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/#{@new_resource.module_name}").first

    if @new_resource.module_path
      @new_resource.module_path(@new_resource.module_path.gsub(/\\/,"/"))
      module_dir = Dir["#{@new_resource.module_path}/*.psd1","#{@new_resource.module_path}/*.psm1","#{@new_resource.module_path}/*.dll"]
      module_dir.each do |filename|
        FileUtils.cp(filename, ps_module_path)
      end
    end

    if @new_resource.download_from
      # Todo: 
    end
  end
end
