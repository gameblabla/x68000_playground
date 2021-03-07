#ifndef COMPRESSION_H
#define COMPRESSION_H

extern unsigned int lz4w_unpack(void * source, void *destination);
extern unsigned int apl_unpack(void *source, void *destination);
extern unsigned int nrv2s_unpack(void *source, void *destination);
extern unsigned int fc8_unpack(void *source, void *destination);

#endif
