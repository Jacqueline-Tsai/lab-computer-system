/*
 * @file cord.c
 * @brief Implementation of cords library
 *
 * 15-513 Introduction to Computer Systems
 *
 * TODO: fill in your name and Andrew ID below
 * @author XXX <XXX@andrew.cmu.edu>
 */

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "cord-interface.h"
#include "xalloc.h"

/***********************************/
/* Implementation (edit this part) */
/***********************************/

/**
 * @brief Checks if a cord is valid
 * @param[in] R
 * @return
 */
bool is_cord(const cord_t *R) {
    // null cord
    if (R == NULL) {
        return true;
    }
    if (cord_length(R) <= 0) {
        return false;
    }
    // leaf node
    if (R->data != NULL && R->left == NULL && R->right == NULL &&
        cord_length(R) == strlen(R->data)) {
        return true;
    }
    // non-leaf node
    if (R->left != NULL && R->right != NULL &&
        cord_length(R) - cord_length(R->left) == cord_length(R->right) &&
        is_cord(R->left) && is_cord(R->right)) {
        return true;
    }
    return false;
}

/**
 * @brief Returns the length of a cord
 * @param[in] R
 * @return
 */
size_t cord_length(const cord_t *R) {
    if (R == NULL) {
        return 0;
    }
    return R->len;
}

/**
 * @brief Allocates a new cord from a string
 * @param[in] s
 * @return
 */
const cord_t *cord_new(const char *s) {
    if (s == NULL || strlen(s) <= 0) {
        return NULL;
    }
    cord_t *new_cord = xmalloc(sizeof(cord_t));
    new_cord->len = strlen(s);
    new_cord->left = NULL;
    new_cord->right = NULL;
    char *new_s = xmalloc(sizeof(char) * (new_cord->len + 1));
    strcpy(new_s, s);
    new_cord->data = new_s;
    return new_cord;
}

/**
 * @brief Concatenates two cords into a new cord
 * @param[in] R
 * @param[in] S
 * @return
 */
const cord_t *cord_join(const cord_t *R, const cord_t *S) {
    if (R == NULL) {
        return S;
    }
    if (S == NULL) {
        return R;
    }
    if (cord_length(R) == 0 || cord_length(S) == 0) {
        return NULL;
    }
    if (cord_length(R) > ((size_t)-1) - cord_length(S)) {
        return NULL;
    }
    cord_t *new_cord = xmalloc(sizeof(cord_t));
    new_cord->len = cord_length(R) + cord_length(S);
    new_cord->left = R;
    new_cord->right = S;
    return new_cord;
}

/**
 * @brief Converts a cord to a string
 * @param[in] R
 * @return
 */
char *cord_tostring(const cord_t *R) {
    char *empty_str = xmalloc(1);
    empty_str[0] = '\0';
    if (R == NULL) {
        return empty_str;
    }
    // leaf node
    if (R->left == NULL && R->right == NULL) {
        char *result = xmalloc(cord_length(R) + 1);
        strcpy(result, R->data);
        return result;
    }
    // non-leaf node
    if (R->left != NULL && R->right != NULL) {
        char *strL = cord_tostring(R->left);
        char *strR = cord_tostring(R->right);
        strcat(strL, strR);
        return strL;
    }
    return empty_str;
}

/**
 * @brief Returns the character at a position in a cord
 *
 * @param[in] R  A cord
 * @param[in] i  A position in the cord
 * @return The character at position i
 *
 * @requires i is a valid position in the cord R
 */
char cord_charat(const cord_t *R, size_t i) {
    assert(i < cord_length(R));
    if (cord_length(R->left) + cord_length(R->right) == 0) {
        return R->data[i];
    }
    if (i < cord_length(R->left)) {
        return cord_charat(R->left, i);
    }
    if (cord_length(R->left) <= i &&
        i < cord_length(R->left) + cord_length(R->right)) {
        return cord_charat(R->right, i - cord_length(R->left));
    }
    return '\0';
}

/**
 * @brief Gets a substring of an existing cord
 *
 * @param[in] R   A cord
 * @param[in] lo  The low index of the substring, inclusive
 * @param[in] hi  The high index of the substring, exclusive
 * @return A cord representing the substring R[lo..hi-1]
 *
 * @requires lo and hi are valid indexes in R, with lo <= hi
 */
const cord_t *cord_sub(const cord_t *R, size_t lo, size_t hi) {
    assert(lo <= hi && hi <= cord_length(R));
    if (lo == hi) {
        return NULL;
    }
    if (lo == 0 && hi == cord_length(R)) {
        return R;
    }
    // leaf node
    if (R->left == NULL && R->right == NULL) {
        cord_t *new_cord = xmalloc(sizeof(cord_t));
        new_cord->len = hi - lo;
        new_cord->left = NULL;
        new_cord->right = NULL;
        char *s = xmalloc(sizeof(char) * (hi - lo + 1));
        strncpy(s, R->data + lo, hi - lo);
        new_cord->data = s;
        return new_cord;
    }
    // non-leaf node
    if (R->left != NULL && R->right != NULL) {
        if (lo < cord_length(R->left) && hi <= cord_length(R->left)) {
            return cord_sub(R->left, lo, hi);
        }
        if (lo < cord_length(R->left) && cord_length(R->left) < hi) {
            cord_t *new_cord = xmalloc(sizeof(cord_t));
            new_cord->len = hi - lo;
            new_cord->left = cord_sub(R->left, lo, cord_length(R->left));
            new_cord->right = cord_sub(R->right, 0, hi - cord_length(R->left));
            new_cord->data = NULL;
            return new_cord;
        }
        if (cord_length(R->left) <= lo &&
            hi <= cord_length(R->left) + cord_length(R->right)) {
            return cord_sub(R->right, lo - cord_length(R->left),
                            hi - cord_length(R->left));
        }
    }
    return NULL;
}
