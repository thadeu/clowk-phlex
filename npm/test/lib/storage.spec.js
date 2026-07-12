import { describe, it, expect } from "vitest"
import { readJSON, writeJSON } from "../../src/lib/storage.js"

describe("lib/storage", () => {
  it("round-trips JSON through a store", () => {
    writeJSON(sessionStorage, "k", { a: 1 })
    expect(readJSON(sessionStorage, "k")).toEqual({ a: 1 })
  })

  it("returns the fallback for a missing key", () => {
    expect(readJSON(sessionStorage, "missing", { fallback: [] })).toEqual([])
    expect(readJSON(sessionStorage, "missing")).toBeNull()
  })

  it("returns the fallback for malformed JSON (never throws)", () => {
    sessionStorage.setItem("bad", "{not json")
    expect(readJSON(sessionStorage, "bad", { fallback: "safe" })).toBe("safe")
  })

  it("honors a validate predicate", () => {
    writeJSON(sessionStorage, "n", 5)
    const isArray = (v) => Array.isArray(v)
    expect(readJSON(sessionStorage, "n", { fallback: [], validate: isArray })).toEqual([])
  })

  it("writeJSON reports success", () => {
    expect(writeJSON(sessionStorage, "ok", 1)).toBe(true)
  })
})
