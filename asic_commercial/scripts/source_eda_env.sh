#!/usr/bin/env bash

if [[ -n "${EDA_ENV_ALREADY_SOURCED:-}" ]]; then
    return 0 2>/dev/null || exit 0
fi
export EDA_ENV_ALREADY_SOURCED=1

source_if_exists() {
    local path="$1"
    [[ -f "$path" ]] || return 0

    local had_errexit=0
    local had_nounset=0
    case $- in
        *e*) had_errexit=1 ;;
    esac
    case $- in
        *u*) had_nounset=1 ;;
    esac

    set +e +u
    # shellcheck disable=SC1090
    . "$path"
    local status=$?

    if [[ "$had_errexit" == "1" ]]; then set -e; fi
    if [[ "$had_nounset" == "1" ]]; then set -u; fi

    return "$status"
}

path_contains_dir() {
    local dir="$1"
    case ":${PATH:-}:" in
        *":${dir}:"*) return 0 ;;
        *) return 1 ;;
    esac
}

prepend_path_if_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || return 0
    path_contains_dir "$dir" && return 0
    export PATH="$dir${PATH:+:${PATH}}"
}

add_path_globs() {
    local pattern
    local dir
    local had_nullglob=0
    shopt -q nullglob && had_nullglob=1
    shopt -s nullglob
    for pattern in "$@"; do
        for dir in $pattern; do
            prepend_path_if_dir "$dir"
        done
    done
    if [[ "$had_nullglob" != "1" ]]; then
        shopt -u nullglob
    fi
}

first_existing_path() {
    local candidate
    for candidate in "$@"; do
        [[ -f "$candidate" ]] || continue
        printf '%s\n' "$candidate"
        return 0
    done
    return 1
}

first_executable_path() {
    local pattern
    local path
    local had_nullglob=0
    shopt -q nullglob && had_nullglob=1
    shopt -s nullglob
    for pattern in "$@"; do
        for path in $pattern; do
            [[ -x "$path" ]] || continue
            printf '%s\n' "$path"
            if [[ "$had_nullglob" != "1" ]]; then
                shopt -u nullglob
            fi
            return 0
        done
    done
    if [[ "$had_nullglob" != "1" ]]; then
        shopt -u nullglob
    fi
    return 1
}

normalize_license_env_family() {
    local primary_name="$1"
    shift
    local current_name
    local primary_value=""

    for current_name in "$primary_name" "$@"; do
        primary_value="${!current_name:-}"
        [[ -n "$primary_value" ]] && break
    done

    [[ -n "$primary_value" ]] || return 0

    for current_name in "$primary_name" "$@"; do
        export "$current_name=$primary_value"
    done
}

if [[ -z "${SYNOPSYS_ENV_SH:-}" ]]; then
    SYNOPSYS_ENV_SH="$(
        first_existing_path \
            /opt/synopsys/snop18.sh \
            /home/synopsys/snop18.sh \
            /home/synopsys/setup.sh \
            /home/app/synopsys/snop18.sh \
        || true
    )"
fi

if [[ -z "${MENTOR_ENV_SH:-}" ]]; then
    MENTOR_ENV_SH="$(
        first_existing_path \
            /opt/mentor/mentor.sh \
            /home/mentor/mentor.sh \
            /home/mentor/setup.sh \
        || true
    )"
fi

if [[ -n "${SYNOPSYS_ENV_SH:-}" ]] && ! source_if_exists "$SYNOPSYS_ENV_SH"; then
    echo "[eda-env][ERROR] failed to source Synopsys env: $SYNOPSYS_ENV_SH" >&2
    return 1 2>/dev/null || exit 1
fi

if [[ -n "${MENTOR_ENV_SH:-}" ]] && ! source_if_exists "$MENTOR_ENV_SH"; then
    echo "[eda-env][ERROR] failed to source Mentor env: $MENTOR_ENV_SH" >&2
    return 1 2>/dev/null || exit 1
fi

add_path_globs \
    /opt/synopsys/*/bin \
    /opt/synopsys/*/*/bin \
    /home/synopsys/*/bin \
    /home/synopsys/*/*/bin \
    /home/app/synopsys/*/bin \
    /home/app/synopsys/*/*/bin \
    /opt/mentor/*/bin \
    /opt/mentor/*/*/bin \
    /home/mentor/*/bin \
    /home/mentor/*/*/bin \
    /home/cadence/*/bin \
    /home/cadence/*/*/bin \
    /home/cadence/*/tools/bin \
    /home/cadence/*/*/tools/bin \
    /home/Xilinx/*/bin \
    /home/Xilinx/*/*/bin \
    /home/app/vivado/*/bin \
    /home/iverilog \
    /home/gtkwave \
    /home/gtkwave/* \
    /home/gtkwave/*/bin

normalize_license_env_family SNPSLMD_LICENSE_FILE SYNOPSYS_LICENSE_FILE LM_LICENSE_FILE VCS_LICENSE_FILE

if [[ -z "${ICC_SHELL_EXEC:-}" ]] && command -v icc_shell >/dev/null 2>&1; then
    export ICC_SHELL_EXEC
    ICC_SHELL_EXEC="$(command -v icc_shell)"
fi

if [[ -z "${ICC_SHELL_EXEC:-}" ]]; then
    ICC_SHELL_EXEC="$(
        first_executable_path \
            /opt/synopsys/*/bin/icc_shell \
            /opt/synopsys/*/*/bin/icc_shell \
            /home/synopsys/*/bin/icc_shell \
            /home/synopsys/*/*/bin/icc_shell \
            /home/app/synopsys/*/bin/icc_shell \
            /home/app/synopsys/*/*/bin/icc_shell \
        || true
    )"
    if [[ -n "${ICC_SHELL_EXEC:-}" ]]; then
        export ICC_SHELL_EXEC
    fi
fi
