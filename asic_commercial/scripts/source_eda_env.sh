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

SYNOPSYS_ENV_SH="${SYNOPSYS_ENV_SH:-/opt/synopsys/snop18.sh}"
MENTOR_ENV_SH="${MENTOR_ENV_SH:-/opt/mentor/mentor.sh}"

if ! source_if_exists "$SYNOPSYS_ENV_SH"; then
    echo "[eda-env][ERROR] failed to source Synopsys env: $SYNOPSYS_ENV_SH" >&2
    return 1 2>/dev/null || exit 1
fi

if ! source_if_exists "$MENTOR_ENV_SH"; then
    echo "[eda-env][ERROR] failed to source Mentor env: $MENTOR_ENV_SH" >&2
    return 1 2>/dev/null || exit 1
fi

if [[ -z "${ICC_SHELL_EXEC:-}" ]] && command -v icc_shell >/dev/null 2>&1; then
    export ICC_SHELL_EXEC
    ICC_SHELL_EXEC="$(command -v icc_shell)"
fi
