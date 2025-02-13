"""Defines all the features this module supports detecting."""

load("@bazel_features_globals//:globals.bzl", "globals")
load("//private:util.bzl", "ge", "lt")

_cc = struct(
    # Whether @bazel_tools//tools/cpp:optional_current_cc_toolchain and the `mandatory` parameter
    # on find_cpp_toolchain are available (#17308).
    # Note: While the target and parameter are available in 6.1.0, they only take effect in Bazel 7.
    find_cpp_toolchain_has_mandatory_param = ge("6.1.0"),
    # Note: In Bazel 6.3 the `grep_includes` parameter is optional and a no-op in the cc_common API
    # In future Bazel versions it will be removed altogether.
    grep_includes_is_optional = ge("6.3.0"),
    # From 7.0.0-pre.20230724.1 on `ObjcProvider` no longer contains linking info
    # https://github.com/bazelbuild/bazel/commit/426f2254669f62b7d332094a0af6d4dc6200ad51
    objc_linking_info_migrated = ge("7.0.0-pre.20230724.1"),
    # https://github.com/bazelbuild/bazel/commit/c8c3878088cb706b820d506a682e1156b7e8c64d
    swift_fragment_removed = ge("8.0.0-pre.20240101.1"),
    # Whether the Unix C/C++ toolchain passes -undefined dynamic_lookup to the
    # macOS linker.  Added in commit
    # https://github.com/bazelbuild/bazel/commit/314cf1f9e4b332955c4800b2451db4e926c3e092
    # and removed again in commit
    # https://github.com/bazelbuild/bazel/commit/4853dfd02ac7440a04caada830b7b61b6081bdfe.
    undefined_dynamic_lookup = ge("0.25.0") and lt("7.0.0-pre.20230118.2"),
    # Whether the treat_warnings_as_errors feature works on macOS.
    # https://github.com/bazelbuild/bazel/commit/3d7c5ae47e2a02ccd81eb8024f22d56ae7811c9b
    treat_warnings_as_errors_works_on_macos = ge("7.1.0"),
)

_external_deps = struct(
    # Whether --enable_bzlmod is set, and thus, whether str(Label(...)) produces canonical label
    # literals (i.e., "@@repo//pkg:file").
    is_bzlmod_enabled = str(Label("//:invalid")).startswith("@@"),
    # Whether module_extension has the os_dependent and arch_dependent parameters.
    # https://github.com/bazelbuild/bazel/commit/970b9dda7cd215a29d73a53871500bc4e2dc6142
    module_extension_has_os_arch_dependent = ge("6.4.0"),
    # Whether repository_ctx#download has the block parameter, allowing parallel downloads (#19674)
    download_has_block_param = ge("7.1.0"),
    # Whether repository_ctx#download has the headers parameter, allowing arbitrary headers (#17829)
    download_has_headers_param = ge("7.1.0"),
    # Whether repository_ctx#extract has unicode filename extraction fix (#18448)
    extract_supports_unicode_filenames = ge("6.4.0"),
)

_flags = struct(
    # This flag was renamed in https://github.com/bazelbuild/bazel/pull/18313
    allow_unresolved_symlinks = (
        "allow_unresolved_symlinks" if ge("7.0.0-pre.20230628.2") else "experimental_allow_unresolved_symlinks"
    ),
)

_rules = struct(
    # Whether the computed_substitutions parameter of ctx.actions.expand_template and ctx.actions.template_dict are stable.
    # https://github.com/bazelbuild/bazel/commit/61c31d255b6ba65c372253f65043d6ea3f10e1f9
    expand_template_has_computed_substitutions = ge("7.0.0-pre.20231011.2"),
    # Whether TemplateDict#add_joined allows the map_each callback to return a list of strings (#17306)
    template_dict_map_each_can_return_list = ge("6.1.0"),
    # Whether coverage_common.instrumented_files_info spports the
    # metadata_files parameter.  Introduced in commit
    # https://github.com/bazelbuild/bazel/commit/ef54ef5d17a013c863c4e2fb0583e6bd209645f2.
    instrumented_files_info_has_metadata_files = ge("7.0.0-pre.20230710.5"),
    # Whether treeartifacts can have symlinks pointing outside of the tree artifact. (#21263)
    permits_treeartifact_uplevel_symlinks = ge("7.1.0"),
)

_toolchains = struct(
    # Whether the mandatory parameter is available on the config_common.toolchain_type function, and thus, whether optional toolchains are supported
    # https://bazel.build/versions/6.0.0/extending/toolchains#optional-toolchains
    has_optional_toolchains = ge("6.0.0"),
)

bazel_features = struct(
    cc = _cc,
    external_deps = _external_deps,
    flags = _flags,
    globals = globals,
    rules = _rules,
    toolchains = _toolchains,
)
