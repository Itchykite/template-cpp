# =======================
#        CONFIG
# =======================

CXX := clang++
BUILD_DIR := build
BIN := $(BUILD_DIR)/app

# Tryby kompilacji
DEBUG_FLAGS   := -Wall -Wextra -std=c++17 -g
RELEASE_FLAGS := -Wall -Wextra -std=c++17 -O2

# Ścieżki źródłowe
SRC_DIRS := src engine graphics audio
TEST_DIR := tests

# Zewnętrzne biblioteki
LDFLAGS := 

# =======================
#     SOURCES & OBJECTS
# =======================

SRC := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
OBJ := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SRC))
DEPS := $(OBJ:.o=.d)

# =======================
#      TARGET RULES
# =======================

# Domyślny target
all: debug

# Kompilacja w trybie debug
debug: CXXFLAGS := $(DEBUG_FLAGS)
debug: $(BIN)

# Kompilacja w trybie release
release: CXXFLAGS := $(RELEASE_FLAGS)
release: $(BIN)

# Linkowanie
$(BIN): $(OBJ)
	@echo "🔗 Linking $@"
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# Kompilacja z generacją zależności
$(BUILD_DIR)/%.o: %.cpp
	@echo "⚙️  Compiling $<"
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

# =======================
#       TESTS
# =======================

TEST_SRC := $(wildcard $(TEST_DIR)/*.cpp)
TEST_OBJ := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(TEST_SRC))
TEST_BIN := $(BUILD_DIR)/tests

tests: CXXFLAGS := $(DEBUG_FLAGS)
tests: $(TEST_BIN)
	@echo "🚀 Running tests..."
	@./$(TEST_BIN)

$(TEST_BIN): $(OBJ) $(TEST_OBJ)
	@echo "🧪 Linking tests..."
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# =======================
#        CLEAN
# =======================

clean:
	@echo "🧹 Cleaning..."
	@rm -rf $(BUILD_DIR)

# =======================
#     INCLUDE DEPS
# =======================

-include $(DEPS)

# =======================
#       PHONY
# =======================

.PHONY: all debug release clean tests

