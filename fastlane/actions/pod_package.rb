module Fastlane
  module Actions
    module SharedValues
      POD_PACKAGE_CUSTOM_VALUE = :POD_PACKAGE_CUSTOM_VALUE
    end

    class PodPackageAction < Action
      def self.run(params)
        command = []

        command << "bundle exec" if params[:use_bundle_exec] && shell_out_should_use_bundle_exec?

        command << "pod package"

        command << " '#{params[:podspec]}'"

        if params[:verbose]
          command << "--verbose"
        end

        command << "--dynamic" if params[:dynamic]
        command << "--embedded" if params[:embedded]
        command << "--library" if params[:library]
        command << "--exclude-deps" if params[:exclude_deps]
        command << "--no-mangle" if params[:no_mangle]
        command << "--force" if params[:force]

        if params[:spec_sources]
          spec_sources = params[:spec_sources].join(",")
          command << "--spec-sources='#{spec_sources}'"
        end

        if params[:subspecs]
          subspecs = params[:subspecs].join(",")
          command << "--subspecs='#{subspecs}'"
        end

        if params[:bundle_identifier]
          bundle_identifier = params[:bundle_identifier]
          command << "--bundle-identifier='#{bundle_identifier}'"
        end

        if params[:configuration]
          configuration = params[:configuration]
          command << "--configuration='#{configuration}'"
        end

        result = Actions.sh(command.join(' '))
        UI.success("Pod package Successfully ⬆️ ")
        return result
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Pod package"
      end

      def self.details
        "Package a podspec into a library."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :use_bundle_exec,
                                         description: "Use bundle exec when there is a Gemfile presented",
                                         is_string: false,
                                         default_value: false),
          FastlaneCore::ConfigItem.new(key: :podspec,
                                       description: "Name of podspec",
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("File must be a `.podspec` or `.podspec.json`") unless value.end_with?(".podspec", ".podspec.json")
                                      end),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                         description: "Allow output detail in console",
                                         optional: true,
                                         is_string: false),
          FastlaneCore::ConfigItem.new(key: :force,
                                         description: "Overwrite existing files",
                                         is_string: false,
                                         default_value: true),
          FastlaneCore::ConfigItem.new(key: :embedded,
                                       description: "Generate embedded frameworks",
                                       is_string: false,
                                       optional: true,
                                       conflicting_options: [:library, :dynamic]),
          FastlaneCore::ConfigItem.new(key: :library,
                                       description: "Lint stops on the first failing platform or subspec",
                                       optional: true,
                                       is_string: false,
                                       conflicting_options: [:embedded, :dynamic]),
          FastlaneCore::ConfigItem.new(key: :dynamic,
                                       description: "Generate dynamic framework",
                                       optional: true,
                                       is_string: false,
                                       conflicting_options: [:embedded, :library]),
          FastlaneCore::ConfigItem.new(key: :no_mangle,
                                       description: "Do not mangle symbols of depedendant Pods",
                                       is_string: false,
                                       optional: true,
                                       conflicting_options: [:dynamic]),
          FastlaneCore::ConfigItem.new(key: :bundle_identifier,
                                       description: "Bundle identifier for dynamic framework",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :configuration,
                                       description: "Build the specified configuration (e.g. Debug)",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :exclude_deps,
                                       description: "Exclude symbols from dependencies",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :spec_sources,
                                         description: "The sources to pull dependant pods from (defaults to https://github.com/CocoaPods/Specs.git)",
                                         optional: true,
                                         is_string: false,
                                         verify_block: proc do |value|
                                           UI.user_error!("pec_sources must be an array.") unless value.kind_of?(Array)
                                         end),
          FastlaneCore::ConfigItem.new(key: :subspecs,
                                         description: "Only include the given subspecs",
                                         optional: true,
                                         is_string: false,
                                         verify_block: proc do |value|
                                           UI.user_error!("subspecs must be an array.") unless value.kind_of?(Array)
                                         end)
        ]
      end

      def self.output
      end

      def self.return_value
        nil
      end

      def self.authors
        ["aron"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.example_code
        [
          'pod_package(podspec: "my.podspec")',
          '# Do not mangle symbols of depedendant Pods.
          pod_package(podspec: "my.podspec", no_mangle: true)',
          '# package a dynamic framework
          pod_package(podspec: "my.podspec", dynamic: true)',
          '# If the podspec has a dependency on another private pod, then you will have to supply the sources
          pod_package(podspec: "my.podspec", spec_sources: ["https://github.com/username/Specs.git", "https://github.com/CocoaPods/Specs.git"])'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
