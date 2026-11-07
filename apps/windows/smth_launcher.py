import os
import shutil
import subprocess
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

APP_NAME = "SMTH OS"
DEFAULT_RAM_MB = 2048
DEFAULT_CPUS = 2

class SmthLauncher:
    def __init__(self, root):
        self.root = root
        root.title("SMTH OS")
        root.geometry("560x390")
        root.minsize(500, 350)
        root.configure(bg="#101014")
        self.iso = tk.StringVar()
        self.qemu = tk.StringVar(value=shutil.which("qemu-system-x86_64") or "")
        self.ram = tk.IntVar(value=DEFAULT_RAM_MB)
        self.cpus = tk.IntVar(value=DEFAULT_CPUS)
        self._build()

    def _label(self, parent, text, size=10, color="#F3F0FA"):
        return tk.Label(parent, text=text, bg="#101014", fg=color,
                        font=("Segoe UI", size))

    def _build(self):
        tk.Label(self.root, text="SMTH", bg="#101014", fg="#A56EFF",
                 font=("Segoe UI", 28, "bold")).pack(pady=(24, 0))
        self._label(self.root, "BOOT THE REAL SMTH OS • LIVE VIRTUAL MACHINE", 9, "#C8F169").pack(pady=(0, 18))
        body = tk.Frame(self.root, bg="#101014")
        body.pack(fill="both", expand=True, padx=28)
        self._label(body, "SMTH OS ISO").grid(row=0, column=0, sticky="w", pady=5)
        tk.Entry(body, textvariable=self.iso, bg="#202027", fg="white",
                 insertbackground="white", relief="flat").grid(row=1, column=0, sticky="ew", ipady=8)
        tk.Button(body, text="Browse", command=self.pick_iso, bg="#A56EFF",
                  fg="#101014", relief="flat").grid(row=1, column=1, padx=(8, 0))
        self._label(body, "QEMU executable (qemu-system-x86_64.exe)").grid(row=2, column=0, sticky="w", pady=(16, 5))
        tk.Entry(body, textvariable=self.qemu, bg="#202027", fg="white",
                 insertbackground="white", relief="flat").grid(row=3, column=0, sticky="ew", ipady=8)
        tk.Button(body, text="Browse", command=self.pick_qemu, bg="#292630",
                  fg="#C8F169", relief="flat").grid(row=3, column=1, padx=(8, 0))
        settings = tk.Frame(body, bg="#101014")
        settings.grid(row=4, column=0, columnspan=2, sticky="w", pady=18)
        self._label(settings, "RAM (MB)").pack(side="left")
        tk.Spinbox(settings, from_=1024, to=8192, increment=512, textvariable=self.ram,
                   width=7, bg="#202027", fg="white", buttonbackground="#A56EFF").pack(side="left", padx=(8, 22))
        self._label(settings, "CPU cores").pack(side="left")
        tk.Spinbox(settings, from_=1, to=8, textvariable=self.cpus, width=4,
                   bg="#202027", fg="white", buttonbackground="#A56EFF").pack(side="left", padx=8)
        body.columnconfigure(0, weight=1)
        tk.Button(self.root, text="BOOT SMTH OS", command=self.boot, bg="#C8F169",
                  fg="#101014", font=("Segoe UI", 12, "bold"), relief="flat",
                  activebackground="#A56EFF", padx=28, pady=12).pack(pady=(0, 12))
        self._label(self.root, "First boot is a live session. Changes may not persist.", 8, "#AAA5B5").pack(pady=(0, 16))

    def pick_iso(self):
        path = filedialog.askopenfilename(filetypes=[("ISO images", "*.iso"), ("All files", "*.*")])
        if path:
            self.iso.set(path)

    def pick_qemu(self):
        path = filedialog.askopenfilename(filetypes=[("QEMU executable", "qemu-system-x86_64.exe"), ("Executable", "*.exe")])
        if path:
            self.qemu.set(path)

    def boot(self):
        iso, qemu = self.iso.get().strip(), self.qemu.get().strip()
        if not os.path.isfile(iso):
            messagebox.showerror("SMTH OS", "Choose the SMTH OS .iso file first.")
            return
        if not os.path.isfile(qemu):
            messagebox.showerror("SMTH OS", "Choose qemu-system-x86_64.exe. Install QEMU for Windows first.")
            return
        if not iso.lower().endswith(".iso"):
            messagebox.showerror("SMTH OS", "The selected file must be an ISO.")
            return
        args = [qemu, "-machine", "q35", "-accel", "tcg,thread=multi",
                "-cpu", "max", "-smp", str(self.cpus.get()),
                "-m", str(self.ram.get()), "-cdrom", iso, "-boot", "d",
                "-vga", "virtio", "-device", "usb-tablet",
                "-nic", "user,model=virtio-net-pci", "-display", "sdl"]
        try:
            subprocess.Popen(args, cwd=os.path.dirname(qemu) or None)
        except Exception as exc:
            messagebox.showerror("Could not start SMTH OS", str(exc))

if __name__ == "__main__":
    root = tk.Tk()
    SmthLauncher(root)
    root.mainloop()
