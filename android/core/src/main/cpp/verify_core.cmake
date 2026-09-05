# Also usable via cmake -P by the native packaging regression tests.
function(verify_clash_core library_path)
    set(rebuild_hint "Rebuild the Android core with: dart setup.dart android --out core")
    if(NOT EXISTS "${library_path}")
        message(FATAL_ERROR "Missing Android core: ${library_path}. ${rebuild_hint}")
    endif()
    execute_process(
        COMMAND "${CMAKE_NM}" -D --defined-only "${library_path}"
        RESULT_VARIABLE nm_result
        OUTPUT_VARIABLE symbols
        ERROR_VARIABLE nm_error
    )
    if(NOT nm_result EQUAL 0)
        message(FATAL_ERROR "Cannot inspect Android core: ${nm_error}. ${rebuild_hint}")
    endif()
    foreach(symbol registerCallbacks setEventListener invokeAction quickStart resetConnections)
        if(NOT symbols MATCHES "[ \t]${symbol}(\r?\n|$)")
            message(FATAL_ERROR
                "Incompatible Android core: ${library_path} is missing ${symbol}. ${rebuild_hint}")
        endif()
    endforeach()
endfunction()
