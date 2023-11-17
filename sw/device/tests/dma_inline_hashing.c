// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/ip/dma/dif/dif_dma.h"
#include "sw/lib/sw/device/base/memory.h"
#include "sw/lib/sw/device/base/mmio.h"
#include "sw/lib/sw/device/runtime/log.h"

#include "hw/top_darjeeling/sw/autogen/top_darjeeling.h"

OTTF_DEFINE_TEST_CONFIG();

status_t execute_test(dif_dma_t *dma) {
  uint32_t transfer_size = 0x100;
  uint32_t expected_digest[8];
  uint32_t digest[8];

  // Copy data first
  dif_dma_transaction_t transaction_1 = {
      .source = {.address = TOP_DARJEELING_RAM_CTN_BASE_ADDR,
                 .asid = kDifDmaSoCControlRegisterBus},
      .destination = {.address = TOP_DARJEELING_RAM_MAIN_BASE_ADDR,
                      .asid = kDifDmaOpentitanInternalBus},
      .total_size = transfer_size,
      .chunk_size = transfer_size,
      .width = kDifDmaTransWidth4Bytes};

  CHECK_DIF_OK(dif_dma_configure(dma, transaction_1));
  CHECK_DIF_OK(
      dif_dma_memory_range_set(dma, TOP_DARJEELING_RAM_MAIN_BASE_ADDR, 0x1000));
  CHECK_DIF_OK(dif_dma_start(dma, kDifDmaSha256Opcode));

  // Read out the digest from the DMA
  CHECK_DIF_OK(dif_dma_sha2_digest_get(dma, kDifDmaSha256Opcode, digest));

  // Read digest in
  dif_dma_transaction_t transaction_2 = {
      .source = {.address = TOP_DARJEELING_RAM_CTN_BASE_ADDR,
                 .asid = kDifDmaSoCControlRegisterBus},
      .destination = {.address = (uint64_t)&expected_digest[0],
                      .asid = kDifDmaOpentitanInternalBus},
      .total_size = 32,
      .chunk_size = 32,
      .width = kDifDmaTransWidth1Byte};

  CHECK_DIF_OK(dif_dma_configure(dma, transaction_2));
  CHECK_DIF_OK(
      dif_dma_memory_range_set(dma, TOP_DARJEELING_RAM_MAIN_BASE_ADDR, 0x1000));
  CHECK_DIF_OK(dif_dma_start(dma, kDifDmaCopyOpcode));

  return OK_STATUS();
}

bool test_main(void) {
  dif_dma_t dma;

  // Initialise DMA.
  CHECK_DIF_OK(
      dif_dma_init(mmio_region_from_addr(TOP_DARJEELING_DMA_BASE_ADDR), &dma));

  return status_ok(execute_test(&dma));
}
