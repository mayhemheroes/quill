#include "quill/Quill.h"
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <string>
#include <string.h>
#include <string_view>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size)
{
  // Start the logging backend thread
  quill::start();

  {
    std::string buf(reinterpret_cast<const char*>(data), size);
    buf.push_back('\0');
    quill::Logger* logger = quill::get_logger();

    // Change the LogLevel to print everything
    logger->set_log_level(quill::LogLevel::TraceL3);

    LOG_TRACE_L1(logger, "This is a log trace l1 {} example", buf.c_str());
    return 0;
  }
}

