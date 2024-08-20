/**
 * @file csim.c
 * @brief Simulates the behavior of a hardware cache memory.
 *
 * This program simulates a cache memory using a trace-driven approach. It reads
 * a memory access trace from a file and simulates the hits, misses, and
 * evictions that occur in a cache with given parameters. The program helps in
 * understanding the performance implications of different cache configurations
 * and policies.
 *
 * Usage:
 * This program is executed from the command line with the following options:
 *   -h          : Prints the help message.
 *   -E <num>    : Number of cache lines per set.
 *   -b <num>    : Block size in bytes.
 *   -s <num>    : Number of set index bits (log2 of the number of sets).
 *   -t <file>   : Trace file to be used for simulation.
 *
 * Example usage:
 *   ./csim -E 4 -b 5 -s 3 -t tracefile.txt
 *
 * Inputs:
 *   The program takes a trace file as input, which contains a sequence of
 * memory access operations. Each line in the trace file represents a single
 * memory access operation and includes the type of operation ('L' for load, 'S'
 * for store), the memory address, and the number of bytes accessed.
 *
 * Modifying the Program:
 * To modify this program, you need to understand its data structures and flow:
 *   - `trace_info` struct: Stores the configuration of the cache and the trace
 * file name.
 *   - `trace_instruction` struct: Represents a single memory access instruction
 * from the trace.
 *   - `trace_line` struct: Represents a single line in the cache.
 *   - `trace_set` struct: Represents a set in the cache, containing multiple
 * lines.
 *
 * Key Functions:
 *   - `get_next_line()`: Reads and parses the next line from the trace file.
 *   - `simulate_cache()`: Simulates the cache based on the parsed trace file
 * and cache configuration.
 *
 * Design Decisions:
 *   - The program uses a Least Recently Used (LRU) policy for cache eviction.
 *   - The program is designed to be modular, with clear separation between
 * parsing the trace file and simulating the cache. This makes it easier to
 * modify and extend.
 *   - Static functions and inline comments are used to enhance code readability
 * and maintainability.
 *
 * Tricky Parts:
 *   - The LRU eviction logic involves updating the `lru_order` of cache lines,
 * which can be subtle and prone to errors if not handled carefully.
 *   - Handling of the dirty bit during evictions requires careful tracking to
 * ensure correctness.
 *
 * This design ensures that the cache simulation is accurate and efficient,
 * making it easier to analyze different cache configurations and their
 * performance characteristics.
 *
 * @date June 16, 2024
 * @version 1.0
 */

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <getopt.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "cachelab.h"

/**
 * @brief Max string length of one line while reading from trace file
 */
#define MAX_LINE_LENGTH 1024

/**
 * @enum cache_status
 * @brief Represents the status of a cache access.
 */
typedef enum { hit = 1, miss = 2, eviction = 3 } cache_status;

/**
 * @struct trace_info
 * @brief Stores information about the cache configuration and the trace file.
 */
typedef struct {
    int num_set;          ///< Number of cache sets
    int num_line;         ///< Number of lines per set
    int num_block;        ///< Block size in bytes
    int weight;           ///< Weight (not used in current implementation)
    const char *filename; ///< Trace file name
} trace_info;

/**
 * @struct trace_instruction
 * @brief Represents a single memory access instruction from the trace.
 */
typedef struct {
    char instruction;      ///< Type of instruction ('L', 'S')
    unsigned long address; ///< Memory address accessed
    int num_bytes;         ///< Number of bytes accessed
} trace_instruction;

/**
 * @struct trace_line
 * @brief Represents a line in the cache.
 */
typedef struct {
    bool empty;              ///< Whether the line is empty
    unsigned long tag;       ///< Tag of the cache line
    bool dirty_bit;          ///< Dirty bit indicating if the line is dirty
    unsigned long lru_order; ///< LRU order for eviction policy
} trace_line;

/**
 * @struct trace_set
 * @brief Represents a set in the cache, containing multiple lines.
 */
typedef struct {
    trace_line *lines;        ///< Array of lines in the set
    unsigned long num_filled; ///< Number of filled lines in the set
} trace_set;

/**
 * @brief Prints usage information for the program.
 *
 * @param[in] argv The command line arguments.
 */
static void usage(char *argv[]) {
    printf("Usage: %s [-h]\n", argv[0]);
    printf("Options:\n");
    printf("  -h    Print this help message.\n");
    printf("Usage: %s -E <num> -b <num> -s <num> -t <file>\n", argv[0]);
}

/**
 * @brief Reads the next line from the trace file and parses it into a
 * trace_instruction structure.
 *
 * @param[in] filename The name of the trace file.
 * @return A pointer to the next trace_instruction structure, or NULL if the end
 * of the file is reached.
 */
trace_instruction *get_next_line(const char *filename) {
    static FILE *fp = NULL;
    static char buffer[MAX_LINE_LENGTH];
    static bool end_of_file = false;

    if (end_of_file) {
        return NULL;
    }

    if (fp == NULL) {
        fp = fopen(filename, "r");
        if (fp == NULL) {
            fprintf(stderr, "Failed to open %s: %s\n", filename,
                    strerror(errno));
            exit(1);
        }
    }

    if (fgets(buffer, MAX_LINE_LENGTH, fp) == NULL) {
        fclose(fp);
        fp = NULL;
        end_of_file = true;
        return NULL;
    }

    size_t len = strlen(buffer);
    if (len < 5 || (buffer[0] != 'L' && buffer[0] != 'S') || buffer[1] != ' ') {
        fprintf(stderr, "Error: Invalid trace instruction\n");
        exit(1);
    }

    if (buffer[len - 1] == '\n') {
        buffer[len - 1] = '\0';
    }

    char *comma = strchr(buffer, ',');
    if (comma == NULL) {
        fprintf(stderr, "Error: Invalid trace instruction\n");
        exit(1);
    }

    *comma = '\0';
    char *part1 = buffer + 2;
    char *part2 = comma + 1;

    for (char *p = part1; *p != '\0'; ++p) {
        if (!isxdigit(*p)) {
            fprintf(stderr, "Error: Invalid trace instruction\n");
            exit(1);
        }
    }
    for (char *p = part2; *p != '\0'; ++p) {
        if (!isdigit(*p)) {
            fprintf(stderr, "Error: Invalid trace instruction\n");
            exit(1);
        }
    }

    *comma = ',';
    trace_instruction *instruction =
        (trace_instruction *)malloc(sizeof(trace_instruction));
    instruction->instruction = buffer[0];
    instruction->address = strtoul(part1, NULL, 16);
    instruction->num_bytes = atoi(part2);
    return instruction;
}

/**
 * @brief Simulates the behavior of a cache memory based on the trace
 * information.
 *
 * @param[in] trace A pointer to the trace_info structure containing the cache
 * parameters and trace file.
 */
void simulate_cache(trace_info *trace) {
    csim_stats_t *stats = (csim_stats_t *)malloc(sizeof(csim_stats_t));
    stats->hits = 0L;
    stats->misses = 0L;
    stats->evictions = 0L;
    stats->dirty_bytes = 0L;
    stats->dirty_evictions = 0L;

    // Initialize empty cache data
    trace_set *cache_data =
        (trace_set *)malloc((1 << trace->num_set) * sizeof(trace_set));
    for (size_t i = 0; i < (1 << trace->num_set); i++) {
        cache_data[i].lines =
            (trace_line *)malloc((size_t)trace->num_line * sizeof(trace_line));
        cache_data[i].num_filled = 0;
        for (size_t j = 0; j < (size_t)trace->num_line; j++) {
            cache_data[i].lines[j].empty = true;
            cache_data[i].lines[j].dirty_bit = false;
        }
    }

    trace_instruction *instruction = NULL;
    while ((instruction = get_next_line(trace->filename)) != NULL) {
        unsigned int set = (instruction->address >> trace->num_block) &
                           ((1 << trace->num_set) - 1);
        unsigned long tag =
            instruction->address >> (trace->num_block + trace->num_set);

        cache_status status = eviction;
        size_t cache_line_index;
        for (cache_line_index = 0; cache_line_index < (size_t)trace->num_line;
             cache_line_index++) {

            if (cache_data[set].lines[cache_line_index].empty) {
                status = miss;
                break;
            }

            if (cache_data[set].lines[cache_line_index].tag == tag) {
                status = hit;
                break;
            }
        }

        if (status == hit) {
            stats->hits++;
            for (size_t i = 0; i < (size_t)trace->num_line; i++) {
                if (!cache_data[set].lines[i].empty &&
                    cache_data[set].lines[i].lru_order >
                        cache_data[set].lines[cache_line_index].lru_order) {
                    cache_data[set].lines[i].lru_order--;
                }
            }
            cache_data[set].lines[cache_line_index].lru_order =
                cache_data[set].num_filled - 1;
        }
        if (status == miss) {
            stats->misses++;
            cache_data[set].lines[cache_line_index].empty = false;
            cache_data[set].lines[cache_line_index].tag = tag;
            cache_data[set].lines[cache_line_index].lru_order =
                cache_line_index;
            cache_data[set].num_filled += 1;
        }
        if (status == eviction) {
            // Find block to evict
            for (size_t i = 0; i < (size_t)trace->num_line; i++) {
                if (cache_data[set].lines[i].lru_order == 0) {
                    cache_line_index = i;
                    break;
                }
            }

            for (size_t i = 0; i < (size_t)trace->num_line; i++) {
                if (!cache_data[set].lines[i].empty &&
                    cache_data[set].lines[i].lru_order >
                        cache_data[set].lines[cache_line_index].lru_order) {
                    cache_data[set].lines[i].lru_order--;
                }
            }
            cache_data[set].lines[cache_line_index].lru_order =
                cache_data[set].num_filled - 1;

            stats->misses++;
            stats->evictions++;
            cache_data[set].lines[cache_line_index].tag = tag;
        }

        if (status == eviction &&
            cache_data[set].lines[cache_line_index].dirty_bit) {
            stats->dirty_evictions++;
            cache_data[set].lines[cache_line_index].dirty_bit = false;
        }
        if (instruction->instruction == 'S') {
            cache_data[set].lines[cache_line_index].dirty_bit = true;
        }

        free(instruction);
    }

    // calculate number of dirty bytes in cache
    for (size_t i = 0; i < (1 << trace->num_set); i++) {
        for (size_t j = 0; j < (size_t)trace->num_line; j++) {
            if (cache_data[i].lines[j].dirty_bit) {
                stats->dirty_bytes++;
            }
        }
    }
    stats->dirty_bytes = stats->dirty_bytes << trace->num_block;
    stats->dirty_evictions = stats->dirty_evictions << trace->num_block;

    printSummary(stats);

    for (size_t i = 0; i < (1 << trace->num_set); i++) {
        free(cache_data[i].lines);
    }
    free(cache_data);
    free(stats);
}

/**
 * @brief Main routine
 */
int main(int argc, char *argv[]) {

    int c;

    trace_info *trace = (trace_info *)malloc(sizeof(trace_info));
    trace->num_line = -1;
    trace->num_block = -1;
    trace->num_set = -1;
    trace->filename = NULL;

    /* Parse command line args */
    while ((c = getopt(argc, argv, "E:b:hs:t:")) != -1) {
        switch (c) {
        case 'E':
            trace->num_line = atoi(optarg);
            break;
        case 'b':
            trace->num_block = atoi(optarg);
            break;
        case 'h':
            usage(argv);
            exit(0);
        case 's':
            trace->num_set = atoi(optarg);
            break;
        case 't':
            trace->filename = optarg;
            break;
        default:
            usage(argv);
            exit(1);
        }
    }

    if (trace->num_line < 0 || trace->num_block < 0 || trace->num_set < 0 ||
        trace->filename == NULL) {
        printf("Error: Missing required argument\n");
        usage(argv);
        exit(1);
    }

    simulate_cache(trace);

    exit(0);
}
